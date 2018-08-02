import lcm
from exlcm import example_t


def handler(channel, data):
	msg = example_t.decode(data)
	print 'Received msg: (%d, %s, %r)' % (msg.timestamp, msg.name, msg.enabled)


lc = lcm.LCM()
lc.subscribe("EXAMPLE", handler)

try:
	while True:
		lc.handle()
except KeyboardInterrupt:
	pass
