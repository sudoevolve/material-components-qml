#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSurfaceFormat>
#include <QtQml/qqml.h>

#include "stylemanager.h"

// ── Extras: conditionally include & register ──────────────────────────
// Each module is guarded by its own MD3_HAS_<NAME> macro, defined by CMake
// when the module's source folder exists under third_party/md3/src/Extras/.

#if defined(MD3_HAS_HOTRELOAD)
#include "hotreloader.h"
#endif

#if defined(MD3_HAS_CHARTS)
#include "LineChart.h"
#include "BarChart.h"
#include "PieChart.h"
#endif

#if defined(MD3_HAS_DATAGRID)
#include "GridModel.h"
#endif

#if defined(MD3_HAS_PERFORMANCE)
#include "PerformanceInfo.h"
#endif

int main(int argc, char *argv[])
{
    QSurfaceFormat format;
    format.setSamples(4);
    QSurfaceFormat::setDefaultFormat(format);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:/qt/qml");

    StyleManager styleManager;
    qmlRegisterSingletonInstance("md3.Core", 1, 0, "StyleManager", &styleManager);

#if defined(MD3_HAS_CHARTS)
    qmlRegisterType<LineChart>("md3.Extras.Charts", 1, 0, "LineChart");
    qmlRegisterType<BarChart>("md3.Extras.Charts", 1, 0, "BarChart");
    qmlRegisterType<PieChart>("md3.Extras.Charts", 1, 0, "PieChart");
#endif

#if defined(MD3_HAS_DATAGRID)
    qmlRegisterType<GridModel>("md3.Extras.DataGrid", 1, 0, "GridModel");
#endif

#if defined(MD3_HAS_PERFORMANCE)
    qmlRegisterSingletonType<PerformanceInfo>(
        "md3.Extras.Performance",
        1,
        0,
        "PerformanceInfo",
        [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
            Q_UNUSED(engine)
            Q_UNUSED(scriptEngine)
            return new PerformanceInfo();
        });
#endif

#if defined(MD3_HAS_HOTRELOAD)
    const bool hotReloadEnabled =
#ifdef QT_DEBUG
        true;
#else
        false;
#endif

    HotReloadRuntime runtime(
        &engine,
        QStringLiteral("{{PROJECT_URI}}"),
        QStringLiteral("Main"),
        QStringLiteral(PROJECT_SOURCE_DIR),
        QStringLiteral("src/App/Main.qml"),
        hotReloadEnabled);
    runtime.start();
#endif  // MD3_HAS_HOTRELOAD

    engine.loadFromModule("{{PROJECT_URI}}", "Main");

    return app.exec();
}
