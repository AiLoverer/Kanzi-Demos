// Copyright 2008-2024 by Rightware. All rights reserved.

#include "data_object_static_list.hpp"

using namespace kanzi;

DataObjectStaticList::DataObjectStaticList(Domain *domain, string_view name) :
    DataObjectList(domain, name)
{
}

// Return count of items on the list.
size_t DataObjectStaticList::itemCount()
{
    return m_items.size();
}

// Acquire item on the list by index.
DataObjectSharedPtr DataObjectStaticList::acquireItem(size_t index)
{
    return m_items.at(index);
}

// Release item on the list by index.
void DataObjectStaticList::releaseItem(size_t /*index*/)
{
    // In this function you release memory or resources associated with a particular item.
    // In this example this function is empty because the sample in this example is small and the list is static.
}

// Add new item at end of the list
void DataObjectStaticList::addItem(DataObjectSharedPtr item)
{
    m_items.push_back(item);
    // Notify the list item constructor that the list data has been modified.
    notifyModified();
}

DataObjectSharedPtr DataObjectStaticList::getItemTemplate()
{
    // The default implementation just returns the first list item.
    // Override to construct the template for a virtual list.
    DataObjectSharedPtr object;
    if (!m_items.empty())
    {
        object = m_items.at(0);
    }
    return object;
}
