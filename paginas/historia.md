# La furgoneta 8707GBG mide un {{ historia_puente.hueco_pct[0] }} % más agua de lo que declara: al taller antes del 26 de junio

Del día del contador sale una contradicción que el parte no ve: el contador da
{{ historia_puente.l_por_servicio_contador[0] }} litros por servicio en 8707GBG, frente a los
{{ historia_puente.l_por_servicio_parte[0] }} que declara la propia furgoneta — el hueco más
grande de toda la flota y, para colmo, en la van que menos declara. Y no es casualidad: es
también la furgoneta con más incidencias del mes ({{ pregunta_3.incidencias_100h[0] }} por cada
100 horas, seis veces la segunda). Proponemos al taller de Subcontratas una inspección de
8707GBG (fuga física y calibración del sensor) y una auditoría del parte de mayo, con decisión
antes del 26 de junio de 2026 sobre qué corregir: la fuga de agua del camión o la del parte que la declara.

```grafico
titular: La furgoneta con más agua en el contador es la que menos declara
modelo: historia_puente
barras: furgoneta → l_por_servicio_parte, l_por_servicio_contador
destacar: 8707GBG
leyenda: lo que declara el parte, lo que mide el contador
orden: desc
```

La segunda prueba apunta en la misma dirección y descarta de paso las explicaciones
fáciles: no es el tipo de lavado ni quién lava — el exceso de 8707GBG se repite en toda su
agenda, con las incidencias concentradas en esta furgoneta sea cual sea el servicio.

```grafico
tipo: calor
titular: No es el tipo de lavado: el exceso de 8707GBG se repite en toda su agenda
modelo: historia_calor
filas: furgoneta
columnas: tipo_lavado
valor: inc_100h
destacar: 8707GBG
orden: desc
```

## Qué proponemos

- **Inspección en taller de 8707GBG.** El equipo de flota, con el jefe de taller, pide cita
  esta misma semana; el informe (fuga física y calibración del contador) para el 26 de junio de 2026.
- **Auditoría del parte de mayo.** Operaciones cruza cada fin de servicio del 18/05 contra los
  litros declarados del parte, con la furgoneta {{ pregunta_4.furgoneta[0] }} como caso de
  referencia: informe el 12 de junio de 2026.

## Qué no sabemos todavía

- El contador cubre **un solo día** (18/05/2026, {{ historia_puente.recargas[0] }} recargas de
  depósito detectadas en toda la flota); el parte, en cambio, cubre {{ stg_parte.filas }}
  servicios del 06/04 al 15/05 de 2026. El +% se mide en ventanas distintas: es la comparación
  más dura que hay disponible y la señal se mantiene en la gran desviación.
- No sabemos **por qué** está el hueco en 8707GBG: puede ser fuga física (el agua se pierde
  antes del lavado) o un sensor mal calibrado; ninguna de las dos hipótesis se puede probar
  con los datos de hoy.
- Las recargas de depósito se corrigen como «llenar el depósito + lo consumido»; si el
  depósito real fuera de otra capacidad, esa corrección sobreestimaría el gasto del tramo.

## La misma historia para cada audiencia

- **Comité de dirección (5 segundos):** «La furgoneta que más agua mide es la que menos declara:
  un {{ historia_puente.hueco_pct[0] }} % de más en 8707GBG, la que más incidencias acumula — con decisión
  para el 26 de junio».
- **Responsable que actúa (1 minuto):** «8707GBG mide {{ historia_puente.l_por_servicio_contador[0] }} litros por
  servicio en el contador y declara {{ historia_puente.l_por_servicio_parte[0] }} en el parte; y acumula
  {{ pregunta_3.incidencias_100h[0] }} incidencias por 100 horas, seis veces la segunda de la flota.
  Dos acciones: inspección en taller (26/06) y auditoría del parte de mayo (12/06)».
- **Equipo de datos (5 minutos):** «El puente parte-contador da {{ historia_puente.l_por_servicio_contador[0] }} litros
  por servicio en el contador frente a {{ historia_puente.l_por_servicio_parte[0] }}, con el resto de la flota entre
  16,89 y 21,74 (fuente: el día del contador del 18/05/2026; el parte, con 687 servicios del 06/04 al
  15/05/2026). Sin la corrección de recargas de plata la comparación ni siquiera existe: la flota sale
  con litros negativos. El mapa de calor por tipo de lavado y el cruce con operario descartan
  que el exceso venga de mezclar servicios ni de quién lava».
