report 50040 "Group Mapping"
{
    Caption = 'Group Mapping';
    ProcessingOnly = true;
    dataset
    {
        dataitem(Item; Item)
        {
            trigger OnAfterGetRecord()
            var
                ProductGroupMapping: Record "Product Group Mapping";
                InventoryGroupMapping: Record "Inventory Group Mapping";
            begin
                Window.Update(1, Item."No.");
                if ProductGroupMapping.get(Item."Gen. Prod. Posting Group") then begin
                    Item.Validate("Old Gen. Prod. Posting Group", "Gen. Prod. Posting Group");
                    // Item.Validate("Gen. Prod. Posting Group", ProductGroupMapping."New Code");
                    Item."Gen. Prod. Posting Group" := ProductGroupMapping."New Code";
                    Item.Modify();
                end else begin
                    Item.Validate("Old Gen. Prod. Posting Group", "Gen. Prod. Posting Group");
                    // Item.Validate("Gen. Prod. Posting Group", '');
                    Item."Gen. Prod. Posting Group" := '';
                    Item.Modify();
                end;

                if InventoryGroupMapping.get(Item."Inventory Posting Group") then begin
                    Item.Validate("Old Inventory Posting Group", "Inventory Posting Group");
                    // Item.Validate("Inventory Posting Group", InventoryGroupMapping."New Code");
                    Item."Inventory Posting Group" := InventoryGroupMapping."New Code";
                    Item.Modify();
                end else begin
                    Item.Validate("Old Inventory Posting Group", "Inventory Posting Group");
                    // Item.Validate("Inventory Posting Group", '');
                    Item."Inventory Posting Group" := '';
                    Item.Modify();
                end;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open('#1#########################');
            end;

            trigger OnPostDataItem()
            begin
                Window.Close();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var
        Window: Dialog;
}
