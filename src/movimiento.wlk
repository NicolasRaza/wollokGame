import wollok.game.*
import equipamento.*
import niveles.*
import entidades.*


 const accionConjDer = new AccionConj(charact = mainCharacter,enemigo = mainCharacter.enemigo())
 
 object accionConjizq inherits AccionConj(charact =mainCharacter.enemigo(), enemigo = mainCharacter){
	
	override method caminar(){
		modoWalkingL.accion(charact, enemigo)
	}
	
	override method volver(){
		modoWalkingR.accion(charact, enemigo)
	}
}
 
class Modo {

    var property descripcion 
    var property velocidad
    var property pasos
	var property time
	var property final
	
    method accionPersonaje(charact, enemigo){
		self.moverPersonaje(charact, enemigo)
				
        if (self.time() == pasos) {
        	game.removeTickEvent(descripcion)   	
			time = final
        }
        
    }

	method accion(charact, enemigo) {
		game.onTick(velocidad, descripcion, {=> self.accionPersonaje(charact, enemigo)})
		
	}
	
	method moverPersonaje(charact, enemigo){
	}
	
}
object modoWalkingR inherits Modo(descripcion = "Walking", velocidad = 40, pasos = 14, time=0,final=0) {

    override method moverPersonaje(charact, enemigo){
    	super(charact, enemigo)
    	time+=1
        charact.position(charact.position().right(1))
       
    }    
}
object modoWalkingL inherits Modo(descripcion = "Walking", velocidad = 40, pasos = 0, time=14,final=14) {

    override method moverPersonaje(charact, enemigo){
    	super(charact, enemigo)
		time -=1
        charact.position(charact.position().left(1))
    }
}

class AccionConj{
	
	var property charact
	var property enemigo
	
	method caminar(){
		modoWalkingR.accion(charact, enemigo)
		
	}
	method volver(){
		modoWalkingL.accion(charact, enemigo)
	}
	method accion(){
		self.statusSwitch(2)
		self.caminar()
		game.schedule(1500,{self.volver()})	
		game.schedule(1500,{self.statusSwitch(1)})
	}
	
	method statusSwitch(case){
		charact.status(case)
		enemigo.status(case)
	}
}
