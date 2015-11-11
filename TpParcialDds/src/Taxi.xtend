

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Taxi {
	Ubicacion ubicacion
	EstadoTaxi estado
	Viaje viajeActual
	Notificador notificador
	int telefono
	
	def actualizarUbicacion(int latitud, int longitud){
		this.ubicacion.latitud = latitud
		this.ubicacion.longitud = longitud
	}
	
	def encontroClienteEnLaCalle(){
		this.estado = EstadoTaxi.Ocupado
	}
	
	def notificarNuevoViaje(Viaje viaje){
		this.viajeActual = viaje
		notificador.notificar(this.telefono,"Nuevo viaje en la zona")
	}
	
	def aceptarViaje(){
		this.estado = EstadoTaxi.Ocupado
		this.viajeActual.aceptado(this)
	}
	
	def rechazarViaje(){
		this.viajeActual.taxisPosibles.remove(this)
		this.viajeActual.notificarTaxiMasCercano()
		viajeActual = null;	
	}
	
	
	def cancelarViaje(){
		viajeActual.cancelarTaxi()
	}
	
	def notificarCancelacion(){
		this.estado = EstadoTaxi.Libre
		notificador.notificar(this.telefono,"El pasajero cancelo el viaje")
		viajeActual = null;
		
	}
}