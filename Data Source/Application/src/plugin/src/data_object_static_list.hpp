// Copyright 2008-2024 by Rightware. All rights reserved.

#ifndef DATA_OBJECT_STATIC_LIST_HPP
#define DATA_OBJECT_STATIC_LIST_HPP

#include <kanzi/core.ui/data/data_object_list.hpp>

using namespace kanzi;

class DataObjectStaticList;

typedef shared_ptr<DataObjectStaticList> DataObjectStaticListSharedPtr;

// DataObjectStaticList is the base class for list data object. 
class XML_DATA_SOURCE_API DataObjectStaticList : public DataObjectList
{
public:
    explicit DataObjectStaticList(Domain *domain, string_view name);

    // Return count of items on the list.
    size_t itemCount() override;

    // Acquire item on the list by index.
    DataObjectSharedPtr acquireItem(size_t index) override;

    // Release item on the list by index.
    void releaseItem(size_t index) override;

    // Add new item at end of the list
    void addItem(DataObjectSharedPtr item);

    // Returns tree structure of the data source for individual list item. 
    // Only hierarchy and object types are valid, the data might not be.
    DataObjectSharedPtr getItemTemplate() override;

protected:
    vector<DataObjectSharedPtr> m_items;
};

#endif // DATA_OBJECT_STATIC_LIST_HPP
