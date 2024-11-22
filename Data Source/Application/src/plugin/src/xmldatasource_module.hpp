// Copyright 2008-2024 by Rightware. All rights reserved.

#ifndef XMLDATASOURCE_MODULE_HPP
#define XMLDATASOURCE_MODULE_HPP

#include <kanzi/core/module/plugin.hpp>


class XML_DATA_SOURCE_API XMLDataSourceModule: public kanzi::Plugin
{
public:

    static void registerModule(kanzi::Domain* domain);

protected:

    MetaclassContainer getMetaclassesOverride() override;
};

#endif
