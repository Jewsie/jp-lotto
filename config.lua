CONFIG = {}

CONFIG.Webhook = 'https://discordapp.com/api/webhooks/webhooklink'

CONFIG.MaxTickets = 5 -- How many tickets a player can buy per session(Set to 0 if you want unlimited amount)

CONFIG.HighAward = 0 -- 0 Means that it will be all the money there's in the pool!
CONFIG.MediumAward = math.random(5, 12) -- Can be a sole number, or a random number generator as it's currently on
CONFIG.LowAward = math.random(1, 3) -- Can be a sole number, or a random number generator as it's currently on