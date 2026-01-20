# Asusctl GUI

A modern, lightweight, and beautiful GUI for [asusctl](https://gitlab.com/asus-linux/asusctl), built with Flutter.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Linux-green.svg)
[![Live Demo](https://img.shields.io/badge/demo-online-green)](https://aydinthefirst.github.io/asusctl_gui/)

Tamamdır aga, lafı uzatmadan düz Markdown formatında çakıyorum. Readme dosyasına veya uygulama içi "Hakkında" kısmına direkt yapıştırabilirsin:

### ✨ Features

- **Sensor Monitor**: View real-time sensor stats and details.
- **Modern UI**: A sleek, glassmorphism-inspired interface designed for aesthetics and usability.

### asusctl provided features

- [x] **Power Profiles**: Easily switch between specific power modes (Quiet, Balanced, Performance).
- [x] **RGB Control**: Customize your keyboard lighting with Aura sync integration.
- [x] **Battery Management**: Set charge limits to prolong battery health.
- [x] **System Info**: View basic system info
- [ ] **Fan Curves**: Since my laptop does not support this feature it is not implemented. Contributions are welcome!

## 🚀 Prerequisites

This application relies on `asusctl` to interact with your hardware.

1.  **Install `asusctl`**: Follow the instructions at [asus-linux.org](https://asus-linux.org).
2.  **Enable the service**:
    ```bash
    systemctl enable --now asusd
    ```

## 🛠️ Installation & Building

### Quick Install

```sh
curl -sSL https://raw.githubusercontent.com/AydinTheFirst/asusctl_gui/main/install.sh | bash
```

### From Source

1.  **Clone the repository**:

    ```bash
    git clone https://github.com/AydinTheFirst/asusctl_gui.git
    cd asusctl_gui
    ```

2.  **Install Flutter**: Ensure you have Flutter installed and configured for Linux desktop.

3.  **Get Dependencies**:

    ```bash
    flutter pub get
    ```

4.  **Run**:

    ```bash
    flutter run
    ```

5.  **Build Release**:
    ```bash
    flutter build linux --release
    ```

## 🤝 Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

## ⚠️ Disclaimer

This is an unofficial tool and is not affiliated with ASUS or the asus-linux team. Use at your own risk.
