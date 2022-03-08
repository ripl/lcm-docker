import lcm
from exlcm import example_t


def handler(channel, data):
	msg = example_t.decode(data)
	print('Received msg: (%d, %s, %r)' % (msg.timestamp, msg.name, msg.enabled))


if __name__ == '__main__':
	lc = lcm.LCM()
	lc.subscribe("EXAMPLE", handler)

	try:
		while True:
			lc.handle()
	except KeyboardInterrupt:
		pass
