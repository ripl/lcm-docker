import lcm
from exlcm import example_t
from time import sleep


if __name__ == '__main__':
	msg = example_t()
	msg.timestamp = 0
	msg.name = "example string"
	msg.enabled = True

	lc = lcm.LCM()

	while True:
		lc.publish("EXAMPLE", msg.encode())
		print('sent')
		sleep(1)
