from twisted.internet import reactor
from twisted.protocols.basic import LineReceiver
from twisted.internet.protocol import Factory, ClientFactory
import re
import sys
import time
import json
import datetime
import urllib
import sys
import logging
import conf

SERVER_HERD = {
	"Alford" : ["Hamilton", "Welsh"],
	"Ball" : ["Holiday", "Welsh"],
	"Hamilton" : ["Ball", "Holiday"],
	"Holiday" : ["Ball", "Hamilton"],
	"Welsh" : ["Alford", "Ball"]
}

class Server(LineReceiver):
	def __init__(self, factory):
		self.factory = factory
		self.name = self.factory.name

	def connectionMade(self):
		logging.info(" CONNECTION MADE with {0}.".format(self.name))

	def connectionLost(self, reason):
		logging.info(" CONNECTION LOST with {0}.".format(self.name))

	def lineReceived(self, line):
		logging.info(" RECEIVED: {0}.".format(line))
		if line[0:6] == "IAMAT ":
			self.handle_IAMAT(line[6:])
		elif line[0:8] == "WHATSAT ":
			self.handle_WHATSAT(line[8:])
		elif line[0:3] == "AT ":
			self.handle_AT(line[3:])
		else:
			self.bad_request(line)

	def handle_AT(self, line):
		message = line.split()
		time_stamp = float(message[2])
		try:
			last_update = self.factory.users[message[0]]["update_time"]
			if time_stamp > last_update: 
				self.update_location(message)
				self.flood(line)
		except KeyError:
			self.update_location(message)
			self.flood(line)

	def handle_IAMAT(self, line):
		message = line.split()
		if len(message) != 3:
			self.bad_request("IAMAT " + line)
		else:
			self.update_location(message)
			self.flood(line)
			time_stamp = float(message[2])
			elapsed_time = time.time() - time_stamp
			reply = "AT " + self.name + " " + str(elapsed_time) + " " + line
			self.sendLine(reply)
			logging.info(" REPLY to IAMAT: {0}.".format(reply))

	def handle_WHATSAT(self, line):
		message = line.split()
		if len(message) != 3:
			self.bad_request("WHATSAT " + line)
		else:
			radius = int(message[1])
			quantity = int(message[2])
			if radius > 50:
				self.bad_request("WHATSAT " + line)
			elif quantity > 20:
				self.bad_request("WHATSAT " + line)
			else:
				message = {"user": message[0], "radius": message[1], "quantity": quantity}
				try:
					location = self.factory.users[message["user"]]["location"]
				except KeyError:
					self.bad_request("WHATSAT " + line)
				radius = message["radius"]
				url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + location + "&radius=" + str(radius) + "&key=" + conf.API_KEY
				response = urllib.urlopen(url)
				json_str = response.read()
				json_data = json.loads(json_str)
				if len(json_data["results"]) > message["quantity"]:
					json_data["results"] = json_data["results"][0:message["quantity"]]
					json_str = json.dumps(json_data, indent=3, sort_keys=True)
				elapsed_time = time.time() - self.factory.users[message["user"]]["update_time"]
				reply = "AT " + self.name + " " + str(elapsed_time) + " " + line + "\n" + json_str
				self.sendLine(reply)
				logging.info(" REPLY to WHATSAT: {0}".format(reply))

	def bad_request(self,line):
		self.sendLine("? " + line)
		logging.error(" BAD REQUEST: {0}".format(line))

	def update_location(self, message):
		location = message[1][:10] + "," + message[1][10:]
		self.factory.users[message[0]] = {"location": location, "update_time": float(message[2])}
		return message

	def flood(self,line):
		for server in SERVER_HERD[self.name]:
			port = conf.PORT_NUM[server]
			reactor.connectTCP("localhost", port, ClientFactory("AT " + line))
		logging.info(" SENT MESSAGE: {0} to servers: {1}.".format("AT " + line, str(SERVER_HERD[self.name])))

class ClientProtocol(LineReceiver):
	def __init__(self, factory):
		self.factory = factory

	def connectionMade(self):
		self.sendLine(self.factory.line)
		self.transport.loseConnection()

class ClientFactory(ClientFactory):
	def __init__(self, line):
		self.line = line

	def buildProtocol(self, addr):
		return ClientProtocol(self)

class ServerFactory(Factory):
	def __init__(self, name):
		self.name = name
		self.users = {}
		filename = self.name + "_" + datetime.datetime.now().strftime("%m-%d-%Y-%H:%M:%S") + ".log"
		logging.basicConfig(filename=filename, level=logging.DEBUG)
		logging.info(" {0} STARTED".format(self.name))

	def buildProtocol(self, addr):
		return Server(self)

	def stopFactory(self):
		logging.info(" {0} CLOSED".format(self.name))

def main(argv):
	if len(sys.argv) != 2:
		print "Usage: python server.py SERVERNAME"
		exit()

	factory = ServerFactory(sys.argv[1])
	reactor.listenTCP(conf.PORT_NUM[sys.argv[1]], factory)
	reactor.run()

if __name__ == "__main__" :
	main(sys.argv[1:])
