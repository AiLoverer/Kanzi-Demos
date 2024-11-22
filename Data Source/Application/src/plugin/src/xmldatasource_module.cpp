// Copyright 2008-2024 by Rightware. All rights reserved.

#include "xmldatasource_module.hpp"
#include "xmldatasource.hpp"

void XMLDataSourceModule::registerModule(Domain* domain)
{
    domain->registerModule<XMLDataSourceModule>("XML_data_source");
}

XMLDataSourceModule::MetaclassContainer XMLDataSourceModule::getMetaclassesOverride()
{
    MetaclassContainer metaclasses;
    metaclasses.push_back(XMLDataSource::getStaticMetaclass());
    return metaclasses;
}

#if defined(XML_DATA_SOURCE_API_EXPORT) || defined(ANDROID)

extern "C"
{

XML_DATA_SOURCE_API Module* createModule(uint32_t /*kanziVersionMajor*/, uint32_t /*kanziVersionMinor*/)
{
    return new XMLDataSourceModule;
}

}

#endif
