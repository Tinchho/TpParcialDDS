import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Cliente {
	Ubicacion ubicacion
	Viaje viajeActual

	//FIXME Agrego el notificador por que no sabia como hacerle llegar el mock en el test
	Notificador notificador

	def solicitarViaje() {
		this.viajeActual = new Viaje(this)
	}

	def consultarUbicacionTaxi() {
		viajeActual.ubicacionTaxi()
	}

	def cancelarViaje() {
		viajeActual.cancelarPasajero()
	}
}
