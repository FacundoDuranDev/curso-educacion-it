# Jobs de Prueba para YARN

Este directorio contiene varios jobs de ejemplo que puedes ejecutar en YARN para demostrar el funcionamiento del sistema.

## Jobs Disponibles

1. **WordCount** - Contador de palabras (MapReduce)
2. **Pi Calculator** - Calculadora de Pi (MapReduce)
3. **Grep** - Búsqueda de patrones en texto (MapReduce)
4. **Teragen/Terasort** - Generación y ordenamiento de datos (MapReduce)
5. **Spark Pi** - Calculadora de Pi con Spark
6. **Spark WordCount** - Contador de palabras con Spark

## Cómo Usar

1. Preparar datos de entrada
2. Ejecutar el job
3. Monitorear con comandos YARN
4. Verificar resultados

## Comandos de Monitoreo

```bash
# Ver aplicaciones activas
yarn application -list

# Ver detalles de una aplicación
yarn application -status <application_id>

# Ver logs de una aplicación
yarn logs -applicationId <application_id>
```
