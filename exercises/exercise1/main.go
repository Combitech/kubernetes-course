package main

import (
	"fmt"
	"log"
	"math"
	"os"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/streadway/amqp"
)

const (
	DOUBLE_PRECISION          = 64
	ENV_VAR_SIGNAL_INTERVAL   = "SIGNAL_SAMPLE_INTERVAL"
	ENV_VAR_SIGNAL_TYPE       = "SIGNAL_TYPE"
	ENV_VAR_SIGNAL_A          = "SIGNAL_A"
	ENV_VAR_SIGNAL_B          = "SIGNAL_B"
	DEFAULT_INTERVAL          = time.Second
	DEFAULT_A                 = 1
	DEFAULT_B                 = 1
	ENV_VAR_RABBITMQ_EXCHANGE = "RABBITMQ_EXCHANGE"
	ENV_VAR_RABBITMQ_USERNAME = "RABBITMQ_USERNAME"
	ENV_VAR_RABBITMQ_PASSWORD = "RABBITMQ_PASSWORD"
	ENV_VAR_RABBITMQ_HOST     = "RABBITMQ_HOST"
	ENV_VAR_SENDER_ID         = "SENDER_ID"
	ENV_VAR_RABBITMQ_VHOST    = "RABBITMQ_VHOST"
	ENV_VAR_RABBITMQ_TOPIC    = "RABBITMQ_TOPIC"
)

type SignalCreator func(a float64, b float64) Signal

type Signal func(time.Duration) float64

func sine(a float64, b float64) Signal {
	return func(t time.Duration) float64 {
		return a * math.Sin(b*t.Seconds())
	}
}

func square(a float64, b float64) Signal {
	return func(t time.Duration) float64 {
		theSine := math.Sin(b * t.Seconds())
		theSign := math.Copysign(1, theSine)
		return a * theSign
	}
}

func line(a float64, b float64) Signal {
	return func(t time.Duration) float64 {
		return a*t.Seconds() + b
	}
}

func zero(_ float64, _ float64) Signal {
	return func(_ time.Duration) float64 {
		return 0
	}
}

func getSignalCreator() SignalCreator {
	value, exists := os.LookupEnv(ENV_VAR_SIGNAL_TYPE)
	if exists {
		fmt.Println(fmt.Sprintf(`%s set to "%s".`, ENV_VAR_SIGNAL_TYPE, value))
	} else {
		fmt.Println(fmt.Sprintf(`%s not set.`, ENV_VAR_SIGNAL_TYPE))
	}
	switch value {
	case "line":
		return line
	case "sine":
		return sine
	case "square":
		return square
	case "zero":
		return zero
	default:
		fmt.Println(`Defaulting to constant zero signal.`)
		return zero
	}
}

func getConstant(envVarName string, def float64) float64 {
	value, err := strconv.ParseFloat(os.Getenv(envVarName), DOUBLE_PRECISION)
	if err != nil {
		log.Printf("Invalid float value for environment variable %s (%v); defaulting to %f.", envVarName, err, def)
		return def
	}
	return value
}

func getSignal(creator SignalCreator) Signal {
	a := getConstant(ENV_VAR_SIGNAL_A, DEFAULT_A)
	b := getConstant(ENV_VAR_SIGNAL_B, DEFAULT_B)
	return creator(a, b)
}

func getInterval() time.Duration {
	duration, err := time.ParseDuration(os.Getenv(ENV_VAR_SIGNAL_INTERVAL))
	if err != nil {
		log.Printf("Invalid value for environment variable %s (%v); defaulting to %v.", ENV_VAR_SIGNAL_INTERVAL, err, DEFAULT_INTERVAL)
		return DEFAULT_INTERVAL
	}
	return duration
}

func failOnError(err error, msg string) {
	if err != nil {
		log.Fatalf("%s: %s", msg, err)
	}
}

func getEnvWithDefault(key, fallback string) string {
	if value, exists := os.LookupEnv(key); exists {
		return value
	}
	return fallback
}

type parameters struct {
	exchange  string
	addresses []string
	id        string
	topic     string
}

func getParameters() parameters {
	exchange := getEnvWithDefault(ENV_VAR_RABBITMQ_EXCHANGE, "sine")
	username := os.Getenv(ENV_VAR_RABBITMQ_USERNAME)
	password := os.Getenv(ENV_VAR_RABBITMQ_PASSWORD)
	host := os.Getenv(ENV_VAR_RABBITMQ_HOST)
	id := os.Getenv(ENV_VAR_SENDER_ID)
	topic := os.Getenv(ENV_VAR_RABBITMQ_TOPIC)
	vhosts := strings.Split(os.Getenv(ENV_VAR_RABBITMQ_VHOST), ";")
	addresses := make([]string, len(vhosts))
	for i, v := range vhosts {
		addresses[i] = fmt.Sprintf("amqp://%s:%s@%s/%s", username, password, host, v)
	}
	return parameters{
		exchange:  exchange,
		addresses: addresses,
		id:        id,
		topic:     topic,
	}
}

func main() {

	p := getParameters()
	signal := getSignal(getSignalCreator())
	interval := getInterval()

	var waitGroup sync.WaitGroup

	waitGroup.Add(len(p.addresses))

	fmt.Println(p.addresses, p.id)
	for _, address := range p.addresses {
		go sendToExchange(sendConfig{
			address:   address,
			exchange:  p.exchange,
			id:        p.id,
			topic:     p.topic,
			interval:  interval,
			signal:    signal,
			waitGroup: waitGroup,
		})
	}

	fmt.Println("Waiting for routines")
	waitGroup.Wait()
	fmt.Println("Exiting")
}

type sendConfig struct {
	address   string
	exchange  string
	id        string
	interval  time.Duration
	signal    Signal
	topic     string
	waitGroup sync.WaitGroup
}

func sendToExchange(c sendConfig) {

	defer c.waitGroup.Done()

	conn, err := amqp.Dial(c.address)

	failOnError(err, "Failed to connect to RabbitMQ")
	defer conn.Close()

	ch, err := conn.Channel()
	failOnError(err, "Failed to open a channel")
	defer ch.Close()

	err = ch.ExchangeDeclare(
		c.exchange, // name
		"topic",    // type
		true,       // durable
		false,      // auto-deleted
		false,      // internal
		false,      // no-wait
		nil,        // arguments
	)
	failOnError(err, "Failed to declare an exchange")

	ticker := time.NewTicker(c.interval)
	defer ticker.Stop()
	start := time.Now()
	for {
		<-ticker.C

		t := time.Now().Sub(start)
		value := c.signal(t)
		valueStringified := fmt.Sprintf("%f", value)
		err = ch.Publish(
			c.exchange, // exchange
			c.topic,    // routing key
			false,      // mandatory
			false,      // immediate
			amqp.Publishing{
				ContentType: "text/plain",
				Body:        []byte(valueStringified),
			},
		)
		if err == nil {
			log.Printf("Sent %s", valueStringified)
		} else {
			log.Printf("Failed to send %s; %s", valueStringified, err)
		}
	}
}
