#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include <QFileInfo>
#include <QStandardPaths>
#include <QSurfaceFormat>
#include "stylemanager.h"

int main(int argc, char *argv[])
{
    // Set default surface format for antialiasing (MSAA 4x)
    QSurfaceFormat format;
    format.setSamples(4);
    QSurfaceFormat::setDefaultFormat(format);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    
    // Ensure StyleManager is initialized early if needed, though QML_SINGLETON should handle it.
    // However, for debugging the undefined issue, we trust QML_SINGLETON with qt_add_qml_module.

    // Define external widgets path
    // Priority:
    // 1. "external_widgets" directory next to the executable (Deployment)
    // 2. Source directory relative to main.cpp (Development)
    
    QString appDir = QCoreApplication::applicationDirPath();
    QString deployedPath = QDir(appDir).filePath("external_widgets");
    
    // Use __FILE__ to locate the source directory dynamically
    QString sourceDir = QFileInfo(__FILE__).dir().absolutePath();
    QString sourcePath = QDir(sourceDir).filePath("external_widgets");
    
    QString externalWidgetsPath;
    
    if (QDir(deployedPath).exists()) {
        externalWidgetsPath = deployedPath;
        qDebug() << "Using deployed external widgets path:" << externalWidgetsPath;
    } else {
        externalWidgetsPath = sourcePath;
        if (!QDir(externalWidgetsPath).exists()) {
            QDir().mkpath(externalWidgetsPath);
        }
        qDebug() << "Using source external widgets path:" << externalWidgetsPath;
    }
    
    engine.rootContext()->setContextProperty("ExternalWidgetsPath", externalWidgetsPath);
    
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("appmd3", "Main");

    return app.exec();
}
