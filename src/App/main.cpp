/*
 * Copyright (C) 2024-2026 sudoevolve (Aino) <sudoevolve@gmail.com>
 * https://github.com/sudoevolve
 * This file is part of the MD3 library.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 */

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QStandardPaths>
#include <QSurfaceFormat>

#ifndef MD3_HAS_EXTRA_CHARTS
#define MD3_HAS_EXTRA_CHARTS 0
#endif
#ifndef MD3_HAS_EXTRA_DATAGRID
#define MD3_HAS_EXTRA_DATAGRID 0
#endif
#ifndef MD3_HAS_EXTRA_HOTRELOAD
#define MD3_HAS_EXTRA_HOTRELOAD 0
#endif
#ifndef MD3_HAS_EXTRA_PERFORMANCE
#define MD3_HAS_EXTRA_PERFORMANCE 0
#endif
#ifndef MD3_HAS_EXTRA_MATHSYMBOLS
#define MD3_HAS_EXTRA_MATHSYMBOLS 0
#endif
#ifndef MD3_HAS_EXTRA_MARKDOWN
#define MD3_HAS_EXTRA_MARKDOWN 0
#endif
#ifndef MD3_HAS_EXTRA_NODEGRAPH
#define MD3_HAS_EXTRA_NODEGRAPH 0
#endif
#ifndef MD3_HAS_EXTRA_GANTT
#define MD3_HAS_EXTRA_GANTT 0
#endif

#if MD3_HAS_EXTRA_HOTRELOAD
#include "hotreloader.h"
#endif

static QVariantMap buildAppFeatures()
{
    QVariantMap features;
    features.insert(QStringLiteral("charts"), MD3_HAS_EXTRA_CHARTS != 0);
    features.insert(QStringLiteral("dataGrid"), MD3_HAS_EXTRA_DATAGRID != 0);
    features.insert(QStringLiteral("hotReload"), MD3_HAS_EXTRA_HOTRELOAD != 0);
    features.insert(QStringLiteral("performance"), MD3_HAS_EXTRA_PERFORMANCE != 0);
    features.insert(QStringLiteral("mathSymbols"), MD3_HAS_EXTRA_MATHSYMBOLS != 0);
    features.insert(QStringLiteral("markdown"), MD3_HAS_EXTRA_MARKDOWN != 0);
    features.insert(QStringLiteral("nodeGraph"), MD3_HAS_EXTRA_NODEGRAPH != 0);
    features.insert(QStringLiteral("gantt"), MD3_HAS_EXTRA_GANTT != 0);
    return features;
}

int main(int argc, char *argv[])
{
    // Set default surface format for antialiasing (MSAA 4x)
    QSurfaceFormat format;
    format.setSamples(4);
    QSurfaceFormat::setDefaultFormat(format);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:/qt/qml");
    engine.rootContext()->setContextProperty("AppFeatures", buildAppFeatures());
    engine.rootContext()->setContextProperty("HotReloadEnabled", false);
    engine.rootContext()->setContextProperty("ProjectSourceDir", QString());

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

#if MD3_HAS_EXTRA_HOTRELOAD
    const bool hotReloadEnabled =
#ifdef QT_DEBUG
        true;
#else
        false;
#endif
    HotReloadRuntime runtime(
        &engine,
        QStringLiteral("md3.App"),
        QStringLiteral("Main"),
        QStringLiteral(PROJECT_SOURCE_DIR),
        QStringLiteral("src/App/Main.qml"),
        hotReloadEnabled,
        false);
    runtime.start();
    return app.exec();
#endif

    engine.loadFromModule(QStringLiteral("md3.App"), QStringLiteral("Main"));
    return app.exec();
}
