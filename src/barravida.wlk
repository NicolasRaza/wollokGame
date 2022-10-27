import entidades.*
import wollok.game.*

class BarraVida {

	var property image = "hp bar 50 of 50.png"
	var property position = game.at(3, 12)
	var property persona

	method cuanta() {
		if(persona.vida() > 0)
		return (50 - persona.vida())
		else return 50
	}

	method image() {
		return ("assets vida/hp bar " + self.cuanta() + " of 50.png")
		 
	}
}

const barraVidaProta = new BarraVida(persona = mainCharacter)

object barraVidaE1 inherits BarraVida{
	
	override method position() = game.at(21,12)
		}

object barraStaminaProta {

	var property image = "stamina 3 of 3.png"
	var property position = game.at(3, 11)
	var property persona = mainCharacter
	
	method cuanta() {
		if(persona.stamina() > 0)
		return persona.stamina()
		else return 0
	}


	method image(){
		return ("assets vida/stamina " + self.cuanta() + " of 3.png")
		
	}
	
	
}

