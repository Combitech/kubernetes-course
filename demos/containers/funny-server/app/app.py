from http.server import BaseHTTPRequestHandler, HTTPServer
import os
import pyjokes

# Configurable parameters
server_name = os.getenv('HOSTNAME', '<unknown>')
server_host = os.getenv('SERVER_HOST', 'localhost')
server_port = int(os.getenv('SERVER_PORT', '8080'))
bg_color = os.getenv('BG_COLOR', 'yellow')
text_color = os.getenv('TEXT_COLOR', 'black')

# Derive styling from configuration
html_styling = f"font-family: Sans-Serif; font-size:25px; color:{text_color}; background-color:{bg_color};"

class MyServer(BaseHTTPRequestHandler):
    """Simple HTTP server"""
    def do_GET(self):
        # Send response; HTTP header + HTML 
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

        self.wfile.write(bytes('<html><head><title>Programmer Jokes</title></head>', 'utf-8'))
        self.wfile.write(bytes(f'<body style="{html_styling}">', 'utf-8'))
        self.wfile.write(bytes(f'<h3>Funny server running on {server_name}</h2>', 'utf-8'))
        self.wfile.write(bytes('<hr/>', 'utf-8'))

        if self.path == '/joke':
            # new funny joke for each page load
            joke = pyjokes.get_joke()
            self.wfile.write(bytes('<blockquote cite="https://pyjok.es/society">', 'utf-8'))
            self.wfile.write(bytes(f'<i>{joke}</i><br/><br/>', 'utf-8'))
            self.wfile.write(bytes('<small>[<a href="https://pypi.org/project/pyjokes">pyjokes</a>]</small>','utf-8'))
            self.wfile.write(bytes('</blockquote>', 'utf-8'))
            self.wfile.write(bytes('<hr/>', 'utf-8'))
            self.wfile.write(bytes('<p>Another <a href="/joke">joke</a>?</p>', 'utf-8'))
        else:
            # point the user to the funny jokes
            self.wfile.write(bytes('<p>Wanna hear a <a href="/joke">joke</a>?</p>', 'utf-8'))

        self.wfile.write(bytes('</body></html>', 'utf-8'))

if __name__ == '__main__':        
    webServer = HTTPServer((server_host, server_port), MyServer)
    print(f'Serving {bg_color} stuff at http://{server_host}:{server_port}')

    try:
        webServer.serve_forever()
    except KeyboardInterrupt:
        pass

    webServer.server_close()
    print('Server stopped.')
