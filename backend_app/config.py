class Config:
    SECRET_KEY = '5791628bb0b13ce0c676dfde280ba245'
    SQLACHEMY_DATABASE_URI = 'postgresql://postgres:testpass@localhost/taxi'
    HOST_URL = '0.0.0.0'
    HOST_PORT = '5000'
    white = ['http://localhost:3000','http://localhost:9000']