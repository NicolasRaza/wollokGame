import entidades.*
import wollok.game.*
import equipamento.*
import mainMenu.*
import barravida.*

class Nivel {
	var property lvl
	var waveLenght
	var property cont
	
	method iniciar(nivel) {
		self.setup()
		lvl = nivel
		waveLenght = lvl + 2
		cont = waveLenght
		self.spawnManager(lvl)
	}
	
	method setup(){
		game.clear()
		game.addVisual(mainCharacter)
		game.addVisual(barraVidaProta)
		game.addVisual(barraStaminaProta)
		game.addVisual(barraVidaE1)
		config.acciones()
		game.showAttributes(mainCharacter)
	}
	
	method spawnManager(nivel) {
		if(cont > 0){
			spawn.generar(nivel, self, nivel, false)
			
			cont -= 1
		}else if(nivel % 3 != 0) {
			
			game.schedule(1000, { pantallaUpgrade.iniciar(nivel)})
		} else {
			game.schedule(1000, { bossScreen.iniciar()})
		}
	}	
}

object nivel1 inherits Nivel{
}

object nivel2 inherits Nivel{
}

object nivel3 inherits Nivel{
}

object bossLevel inherits Nivel{
	override method iniciar(nivel){
		self.setup()
		lvl = nivel
		waveLenght = lvl
		cont = waveLenght
		self.spawnManager(lvl)
	}
	
	override method spawnManager(nivel){
		if(cont > 0){
			spawn.generar(nivel, self, nivel, true)
			
			cont -= 1
		}else{
			game.schedule(1000, { winScreen.iniciar()})
			game.schedule(1500, { game.stop()})
		}
	}
}

object pantallaUpgrade {
	var property nivel
	method iniciar(_nivel) {
		nivel = _nivel + 1
		upgradeBackGround.nextlvl(nivel)
		game.clear()
		game.addVisual(upgradeBackGround)
		
		//Le da stamina(pociones) al player
		if(mainCharacter.stamina() < 3){
			mainCharacter.staminaUp()
		}
		game.schedule(1800, { self.accion()})
	}
	
	method accion(){
		if(nivel == 2){
			nivel2.iniciar(nivel)
			mainCharacter.equipUpgrade(2)
		}else if(nivel == 3){
			nivel3.iniciar(nivel)
			mainCharacter.equipUpgrade(3)
		}
		
	}
	
}

object bossScreen{
	var property image = "assets/bossScreen.png"
	var property position = game.at(0, 0)
	method iniciar(){
		game.clear()
		game.addVisual(self)
		
		//Le da stamina(pociones) al player
		if(mainCharacter.stamina() < 3){
			mainCharacter.staminaUp()
		}
		game.schedule(1200, {bossLevel.iniciar(1)})
		
	}
}

object gameEnd{
	var property image = "assets/gameover.png"
	var property position = game.at(0, 0)
	method iniciar(){
		game.clear()
		game.addVisual(self)
		game.schedule(2300, { game.stop() })
	}
}

object winScreen{
	var property image = "assets/gamecomplete.png"
	var property position = game.at(0, 0)
	method iniciar(){
		game.clear()
		game.addVisual(self)
		game.schedule(3400, { game.stop() })
	}
}
object mainMenu {

	var property selected
	const backgroundMusic = game.sound("sounds/introOST.mp3")

	method iniciar() {
		game.clear()

		game.addVisual(menuBackground)
		game.addVisual(start)
		game.addVisual(quit)
		self.introMusic()
		config.mainMenu()
	}

	method down() {
		if (quit.selected()) {
			self.selected(start)
		} else self.selected(quit)
	}

	method up() {
		if (start.selected()) {
			self.selected(quit)
		} else self.selected(start)
	}

	method action() {
		selected.action()
	}

	method introMusic() {
		game.schedule(100, { backgroundMusic.play()})
	}

}

object config {

	method mainMenu() {
		keyboard.up().onPressDo({ mainMenu.up()})
		keyboard.down().onPressDo({ mainMenu.down()})
		keyboard.enter().onPressDo({ mainMenu.action()})
	}

	method acciones() {
		keyboard.a().onPressDo({ mainCharacter.atacar(mainCharacter.enemigo())})
		keyboard.s().onPressDo({ mainCharacter.defender()})
		keyboard.c().onPressDo({ mainCharacter.curar()})
	}
}

