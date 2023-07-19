# jp-lotto
 A simple lotto system for RSGCore RedM

This is a simple lotto script, I know it's not technically lore of that time, however there was some kind of lotto system and I don't know how it worked back then, or how I would make it work.
But this is just a simple way for players to earn money aswell!

Config File

```CONFIG = {}

CONFIG.Webhook = 'https://discordapp.com/api/webhooks/webhooklink'

CONFIG.MaxTickets = 5 -- How many tickets a player can buy per session(Set to 0 if you want unlimited amount)

CONFIG.HighAward = 0 -- 0 Means that it will be all the money there's in the pool!
CONFIG.MediumAward = math.random(5, 12) -- Can be a sole number, or a random number generator as it's currently on
CONFIG.LowAward = math.random(1, 3) -- Can be a sole number, or a random number generator as it's currently on

CONFIG.HighAwardChance = 1 -- Only 1% chance to win the highest reward
CONFIG.MediumAwardChance = 5 -- 5%(4% Technically as it's above HighAwardChance and up to Selected) chance to win the medium award
CONFIG.LowAward = 20 -- 20%(19% Technically as it's above MediumAwardChance and up to Selected) chance to win the medium award```

Remember to add lottoticket to your rsg-core/shared/items.lua file!

```['lottoticket'] = {['name'] = 'lottoticket', ['label'] = 'Lottery Ticket', ['weight'] = 50,  ['type'] = 'item', ['image'] = 'lottoticket.png', ['unique'] = false, ['useable'] = true,  ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'Try your luck!'},```
