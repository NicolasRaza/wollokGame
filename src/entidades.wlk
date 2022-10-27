import wollok.game.*
import equipamento.*
import niveles.*
import movimiento.*
import barravida.*

class Character {

	var vida
	var stamina = 3
	var agilidad		//numero entre 0 y 100, representa porcentaje
	var arma
	var property armadura
	var barName
	
	// status list
	// 0 = dead
	// 1 = idle
	// 2 = !idle
	var property status = 1
	var property defiende = false
	var property imagen
	var property position
	var property nivel

	method image() {
		return imagen
	}
	
	method stamina() = stamina
	method vida() = vida
	method danioBase() = 5
	
	method defensaBase() = 5

	method atacar(enemigo) {
	}

	method defender(){}

	method recibirDano(danio) {
		var danioRecibido = danio																		//\  Guarda daño en variable local 
		//if(status == 1){																				// | Si esta defendiendo reduce daño a la mitad
			if (defiende) { danioRecibido/= 2 }		 														
			game.schedule(900,{cambioImagen.roja(self)})
			game.schedule(1500,{cambioImagen.normal(self)})
			game.schedule(900,{if (not (0.randomUpTo(100).between(0,agilidad))) vida -= 0.max(new Range(start = danioRecibido-5, end = danioRecibido).anyOne())})	//> Daño entre -5 ataque recibido y ataque recibido
		//}	else {null}																					
	
	}
}

object mainCharacter inherits Character(position = game.at(0, 1), vida = 50, agilidad = 5, arma = new Arma(danio=5, nombre='?'), armadura = new Armadura(reduccionDanio=5, nombre='?'), imagen="assets/knight1.png",barName = barraVidaProta) {

	var property enemigo
	
	override method danioBase() = 45

	method equipUpgrade(_level){
		arma.danio(arma.danio()+arma.danio()*2/3)											//\ Aumenta ataque y defensa
		armadura.reduccionDanio(armadura.reduccionDanio()+armadura.reduccionDanio()*2/3)	/// en 2/3
		if(_level == 2){
			//image = "assets/knight2.png"
			self.imagen("assets/knight2.png")
			
		}else{
			//image = "assets/knight3.png"
			self.imagen("assets/knight3.png")
			
		}
	}
	
	override method atacar(enemigo1) {
		if (enemigo1.status() == 1 && self.status() == 1) {
			accionConjDer.accion()
			enemigo1.recibirDano(self.danioBase()+arma.danio()-enemigo1.armadura().reduccionDanio())
			position = game.at(0, 1)			
		} 
	}
	
	override method defender() {		
		self.defiende(true)
		game.schedule(1,{cambioImagen.gris(self)})
		enemigo.atacar(self)
		self.defiende(false)
		game.schedule(2000,{cambioImagen.normal(self)})
	}
	
	override method recibirDano(danio) {
		var danioRecibido = danio																		//\  Guarda daño en variable local 
																										// | Si esta defendiendo reduce daño a la mitad
		super(danio)
		game.schedule(900,{if (vida <= 0) {
			game.removeVisual(self)
			self.status(0)
			game.schedule(1500, {gameEnd.iniciar()})
		}})
	}
	
	method curar() {
		if(stamina > 0 and vida < 35){
			stamina-=1
			vida += 15
		}
	}
	
	//Metodo que se utiliza al temrinar cada etapa. Subi la stamina(pociones) en 1
	method staminaUp(){
		stamina += 1
	}

}

class Enemy inherits Character {
	

var property enemigo = mainCharacter

	method visual() {
		game.addVisual(self)
	}

	override method recibirDano(danio) {
		var danioRecibido = danio																		//\  Guarda daño en variable local 
																										// | Si esta defendiendo reduce daño a la mitad
		super(danio)
		game.schedule(900,{if (vida <= 0) {
			game.schedule(1000, { game.removeVisual(barraVidaE1)})
			game.schedule(1000,{game.removeVisual(self)})
			self.status(0)
			game.schedule(2000,{nivel.spawnManager(nivel.lvl())})	
			if (nivel.cont() > 0) game.schedule(2000, { game.addVisual(barraVidaE1) })					
		} else{
			game.schedule(2200,{self.atacar(mainCharacter)})			
		}
	})}
	
	override method atacar(enemigo1) {
		if (enemigo1.status() == 1 && self.status() == 1) {
			accionConjizq.accion()
			enemigo1.recibirDano(self.danioBase()+arma.danio()-enemigo1.armadura().reduccionDanio())
			position = game.at(18, 1)
		} 
	}

}


object cambioImagen{
	
	method roja(personaje){ 
		if (personaje.imagen().endsWith("Gris.png")) personaje.imagen(personaje.image().replace("Gris.png", "Rojo.png"))
		else personaje.imagen(personaje.image().replace(".png", "Rojo.png"))		
	}
	
	method gris(personaje){ personaje.imagen(personaje.image().replace(".png", "Gris.png")) }
	
	method normal(personaje){
		if (personaje.imagen().endsWith("Rojo.png")){
			if (personaje.defiende()) personaje.imagen(personaje.image().replace("Rojo.png", "Gris.png"))
			else personaje.imagen(personaje.image().replace("Rojo.png", ".png"))
		} else if (personaje.imagen().endsWith("Gris.png")) { if (not personaje.defiende()) personaje.imagen(personaje.image().replace("Gris.png", ".png")) } 
	}		
}

object spawn {

	const bestias = [ "assets/goblin.png", "assets/skeleton.png", "assets/demon.png" ]
	const boss = ["assets/boss.png"]
	
	method generar(wave, _nivel, numNivel, special) {
		if(special){
			const enemigo = new Enemy(position = game.at(18, 1), vida = 50, stamina = 0, arma = new Arma(danio=20 * wave, nombre='?'), armadura = new Armadura(reduccionDanio=50 * wave, nombre='?'), agilidad = 15 * wave, imagen = boss.anyOne(), nivel = _nivel,barName = barraVidaE1)
		} else {
			const enemigo = new Enemy(position = game.at(18, 1), vida = 50, stamina = 0, arma = new Arma(danio=(5*numNivel) + wave, nombre='?'), armadura = new Armadura(reduccionDanio=(5*numNivel) + wave, nombre='?'), agilidad = 5, imagen = bestias.anyOne(), nivel = _nivel,barName = barraVidaE1)
		}
		mainCharacter.enemigo(enemigo)
		//cambia entidad enemigo a mover
		accionConjizq.charact(enemigo)
		barraVidaE1.persona(enemigo)
		enemigo.visual() 
	}

}

object upgradeBackGround{
	var property image = "assets/nextlvl1.png"
	var property position = game.at(0, 0)
	
	method nextlvl(_nivel){
		if(_nivel == 3){
			image = "assets/nextlvl2.png" 
		}
	}
}

object menuBackground {

	var property image = "assets/menu_background.png"
	var property position = game.at(0, 0)

}

class MenuOpt {

	var property image
	var property position
	var property selected = mainMenu.selected() == self

}

object start inherits MenuOpt {

	override method image() {
		if (mainMenu.selected() == self) {
			return "assets/start_selected.png"
		} else return "assets/start.png"
	}

	override method position() = game.at(24, 7)

	method action() {
		nivel1.iniciar(1)
	}

}

object quit inherits MenuOpt {

	override method image() {
		if (mainMenu.selected() == self) {
			return "assets/quit_selected.png"
		} else return "assets/quit.png"
	}

	override method position() = game.at(24, 6)

	method action() {
		game.stop()
	}

}

