
interface Notificador {
	def void notificarNuevoViaje(Taxi taxi, Viaje viaje)
	def void notificarViajeRechazo(Cliente cliente)
	def void notificarViajeAceptado(Cliente cliente, Viaje viaje)
	}