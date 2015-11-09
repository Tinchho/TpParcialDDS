interface Notificador {
	def void notificarNuevoViaje(Taxi taxi, Viaje viaje)

	def void notificarViajeRechazo(Cliente cliente)

	def void notificarViajeAceptado(Cliente cliente, Viaje viaje)

	def void notificarCancelacionACliente(Cliente cliente)

	def void notificarCancelacionATaxi(Taxi taxi)
}
