import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Cliente {
	Ubicacion ubicacion
	Viaje viajeActual
	//FIXME Agrego el notificador por que no sabia como hacerle llegar el mock en el test
	Notificador notificador
	
	def solicitarViaje() {
		new Viaje(this)
	}
	
	def viajeAceptado(Viaje viajeAceptado){
		this.viajeActual = viajeAceptado
	}
	
	def consultarUbicacionTaxi(){
		viajeActual.ubicacionTaxi()
	}
}
