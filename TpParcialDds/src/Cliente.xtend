import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Cliente {
	Ubicacion ubicacion
	Viaje viajeActual
	Notificador notificador
	int telefono

	def solicitarViaje() {
		this.viajeActual = new Viaje(this)
		return viajeActual	
	}

	def consultarUbicacionTaxi() {
		viajeActual.ubicacionTaxi()
	}

	def cancelarViaje() {
		viajeActual.cancelarPasajero()
	}
	
	def notificarViajeAceptado(){
		notificador.notificar(this.telefono,"El viaje ha sido aceptado")
	}
	
	def notificarCancelacion(){
		notificador.notificar(this.telefono,"El taxista ha cancelado el viaje")
	}
	def notificarViajeRechazado(){
		notificador.notificar(this.telefono,"Ningun taxi esta disponible en este momento en tu zona")
	}
}
