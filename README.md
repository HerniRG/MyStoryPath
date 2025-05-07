# 📚 MyStoryPath – Elige tu propia aventura... con IA 🤖

**MyStoryPath** es una app que recupera la esencia de los clásicos libros de *"Elige tu propia aventura"*, pero combinada con la potencia de la inteligencia artificial moderna.  
Genera historias interactivas en tiempo real basadas en tus decisiones, usando el modelo **Mistral‑7B‑Instruct** a través de **OpenRouter**.

---

## 🚀 ¿Cómo funciona?

1. Crea tu personaje: elige un nombre, su rol, personalidad, mundo y género narrativo.
2. La IA genera el inicio de la historia con varias decisiones posibles.
3. Tú eliges qué hacer... ¡y la historia continúa!
4. Al final, puedes pulsar "End" para generar un epílogo automático.

---

## 🛠️ Stack técnico

- **SwiftUI** + **MVVM** + **Combine**
- Llamadas a API con `async/await`
- Modelo **Mistral-7B-Instruct** desde OpenRouter
- UI con animaciones suaves, autoscroll y efecto "máquina de escribir"
- Parser personalizado para detectar decisiones de forma flexible

---

## 🔐 Configuración local

Para ejecutar la app necesitas crear un archivo con tu clave de OpenRouter.

### 📄 Crea `Secrets.plist` dentro de `MyStoryPath/Resources/`

Archivo → Nuevo → Archivo → *Property List*  
Ubicación: `MyStoryPath/Resources/Secrets.plist`

O bien crea el archivo manualmente con este contenido:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" 
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>OPENROUTER_API_KEY</key>
    <string>tu_clave_aquí</string>
</dict>
</plist>
```

> ⚠️ **Nunca subas este archivo al repositorio.** Ya está incluido en el `.gitignore`.

---

## 💡 Idea personal

Llevaba tiempo queriendo hacer algo con IA, y de paso revivir la nostalgia de los libros que me encantaban de pequeño. Este finde me puse manos a la obra y monté este primer MVP.

---

## 🧪 Próximos pasos

- Guardar progreso y decisiones del jugador
- Sistema de logros y múltiples finales
- Modo narrado por voz
- Compartir tu historia

---

**¡Gracias por leer!**  
Si te gusta el proyecto, dale ⭐️ o échale un ojo al código.

---

🎨 *Hecho con mucho cariño por [Hernán Rodríguez](https://github.com/HerniRG)*