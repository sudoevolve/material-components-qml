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
#include <QStandardPaths>
#include <QSurfaceFormat>
#include <QtQml/qqml.h>
#include "stylemanager.h"

int main(int argc, char *argv[])
{
    // Set default surface format for antialiasing (MSAA 4x)
    QSurfaceFormat format;
    format.setSamples(4);
    QSurfaceFormat::setDefaultFormat(format);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:/qt/qml");

    StyleManager styleManager;
    qmlRegisterSingletonInstance("md3.Core", 1, 0, "StyleManager", &styleManager);

    engine.loadFromModule(QStringLiteral("md3.App"), QStringLiteral("Main"));

    return app.exec();
}
