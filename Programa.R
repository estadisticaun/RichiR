# Instalar Paquetes requeridos ----

install.packages(c("readxl", "tidyverse", "klaR"))


# Cargar librerías ----

library(tidyverse) 
library(readxl)  
library(klaR)


# Importar datos ----

Fuente <- read_excel("Datos/Imagenes.xlsx", sheet = "Hoja1")

# Transformar ----

# Ordenar/transformar datos originales (Tidy Data)

Datos <- Fuente %>% pivot_wider(names_from = VARIABLE, 
                                values_from = IMAGEN) %>% 
                                replace(is.na(.), 0) %>% 
                                mutate(ID = paste0("I", INDIVIDUO)) 

# Crear conjunto de datos sin varible de identificación (ID)

DatosC <- Datos[, c(2:81)]   


# Fase de Análisis ----

# Componente Descriptivo - OPCIONAL

# Tabla

Porcentaje <- Datos[, c(1:81)] %>% 
  pivot_longer(-INDIVIDUO, names_to = c("Imagen"), values_to = "Valor") %>% 
  group_by(Imagen, Valor) %>% count() %>% 
  pivot_wider(names_from = Valor, 
              values_from = n) %>% 
  rename(Imagen = Imagen, No = `0`, Sí = `1`) %>% 
  arrange(desc(Sí)) 

# Gráfico

Datos[, c(1:81)] %>% 
  pivot_longer(-INDIVIDUO, names_to = c("Imagen"), values_to = "Valor") %>% 
  ggplot(aes(x=Imagen, fill = factor(Valor))) +
  geom_bar(position = "fill") +
  coord_flip() +  
  scale_y_continuous(labels = scales::percent) 


# Fase de Análisis ---

Cluster <- kmodes(data = DatosC, modes = 2, iter.max = 20, weighted = FALSE)
Datos$Grupo <- Cluster$cluster
Datos <- Datos %>% mutate(Agrupacion = paste0("Cluster", Grupo))
DatosF <- Datos %>% dplyr::select(-c(ID, Grupo))

# Exportar resultados ---- 

write.csv(Porcentaje, "Analisis/Porcentaje.csv") # Tabla de frecuencias por imagen
write.csv(DatosF, "Analisis/Clusters.csv") # Tabla con cluster estimados/creados



  
