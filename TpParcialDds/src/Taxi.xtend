

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Taxi {
	Ubicacion ubicacion
	EstadoTaxi estado
	Viaje viajeActual
	
	def actualizarUbicacion(int latitud, int longitud){
		this.ubicacion.latitud = latitud
		this.ubicacion.longitud = longitud
	}
	
	def encontroClienteEnLaCalle(){
		this.estado = EstadoTaxi.Ocupado
	}
	
	def aceptarViaje(Viaje viaje){
		this.estado = EstadoTaxi.Ocupado
		this.viajeActual = viaje
		viaje.aceptado(this)
	}
	
	def rechazarViaje(Viaje viaje){
		viaje.notificarSiguienteMasCercano(this)
	}
	
	def cancelarViaje(){
		this.estado = EstadoTaxi.Libre
		this.viajeActual.cancelarTaxi()
		viajeActual = null;
		
	}
}