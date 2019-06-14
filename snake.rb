require 'ruby2d'
SIZE = 2
TILE_SIZE = 16 * SIZE
SPEED = 8
set width: 853, height: 640
set title: "Snake"
$player_head = Rectangle.new(x: 160*SIZE, y: 304*SIZE, z: 1, width: TILE_SIZE, height: TILE_SIZE, color: '#2EFF40')
$fruit = Rectangle.new(x: rand(1..18)*TILE_SIZE, y: rand(1..18)*TILE_SIZE, width: TILE_SIZE, height: TILE_SIZE,  color: 'red')
line = Line.new( x1: 322*SIZE, y1: 0,  x2: 322*SIZE, y2: 320*SIZE,  width: 2,  color: 'lime')
points_text = Text.new("SCORE: 0", x: 332*SIZE, y: 44*SIZE)
$hit_sound = Sound.new('sound/hit.wav')
$ping_sound = Sound.new("sound/ping.wav")
$background_music = Music.new("sound/Serge_Prokofiev_-_Toccata,_op._11_(Martha_Argerich,_1962).flac.ogg")
$background_music.loop = true

def snake_crash # snake was hitting itself or border
	$hit_sound.play
	$player_body.each do |o|
		o.remove
	end
	load
end
def load #set up new game
	$player_head.x = 160*SIZE
	$player_head.y = 304*SIZE
	$player_body = Array.new # body of the snake
	$player_angle = 0 # direction of snake
	$length = 3 # start legth
	$points = 0 # score of player
	$pause = true
	$fruit.x = rand(1..18)*TILE_SIZE
	$fruit.y = rand(1..18)*TILE_SIZE
	$dtotal = 0 # keeps track how much time passed since snake moved
	$background_music.stop
	$background_music.play
end
def game_pause
	$pause = true
	$background_music.pause
end
def game_unpause
	if $pause
		$pause = false
		$dtotal = 0
		$background_music.resume
	end
end
on :key_down do |event|
	key = event.key
	if key == "p" or key == "space"
		if $pause
			game_unpause
		else
			game_pause
		end
	elsif key == "escape"
		close
	elsif key == "up"
		if $player_angle != 180
			$player_angle = 0
		end
		game_unpause
	elsif key == "left"
		if $player_angle != 90
			$player_angle = 270
		end
		game_unpause
	elsif key == "down"
		if $player_angle != 0
			$player_angle = 180
		end
		game_unpause
	elsif key == "right"
		if $player_angle != 270
			$player_angle = 90
		end
		game_unpause
	end
end
update do
	$dtotal += 1
	# check if it is time for snake to move
	if not $pause and $dtotal > SPEED
		$dtotal -= SPEED
		$player_body.insert(0,
			Rectangle.new(x: $player_head.x, y: $player_head.y, z: 1, width: TILE_SIZE, height: TILE_SIZE, color: 'green'))
		if $player_body.count >= $length
			$player_body[-1].remove
			$player_body.pop
		end
		if $player_angle == 0
			$player_head.y -= TILE_SIZE
		elsif $player_angle == 270
			$player_head.x -= TILE_SIZE
		elsif $player_angle == 180
			$player_head.y += TILE_SIZE
		elsif $player_angle == 90
			$player_head.x += TILE_SIZE
		end
		if $player_head.x  >= 320 * SIZE or $player_head.x < 0 or
			$player_head.y >= 320 * SIZE or $player_head.y < 0
				snake_crash
		end
		# fruit eating
		if $player_head.x  == $fruit.x and $player_head.y == $fruit.y
			$length += 1
			$ping_sound.play
			$fruit.x = rand(1..18)*TILE_SIZE
			$fruit.y = rand(1..18)*TILE_SIZE
			$fruit.opacity = 0
			$points += 1000 - (SPEED/10)
			points_text.text = "SCORE: " + $points.to_s
		end
		## check for collision
		$player_body.each do |o|
			if $player_head.x == o.x and $player_head.y == o.y
				snake_crash
			end
		end
		# animate the fruit
		if $fruit.opacity < 1
			$fruit.opacity += 0.1
		end
	end
end
load
show
