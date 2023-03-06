xmlport 50031 "Import Item Vendor"
{
    //改报表用于期初到库存
    Caption = 'Import Item Vendor';
    Direction = Import;
    FieldDelimiter = '"';
    FieldSeparator = ',';
    Format = VariableText;
    FormatEvaluate = Legacy;
    TextEncoding = WINDOWS;

    schema
    {
        textelement(Root)
        {
            tableelement(Item; Item)
            {
                XmlName = 'ProductionBOMLine';
                AutoSave = false;
                textelement("G_No") { MinOccurs = Zero; }
                textelement("G_VendorNo") { MinOccurs = Zero; }
                textelement("G_VendorItemNo") { MinOccurs = Zero; }
                textelement("G_LeadTime") { MinOccurs = Zero; }

                trigger OnBeforeInsertRecord()
                begin

                end;

                trigger OnAfterInsertRecord()
                var
                    ProdGroupMapping: Record "Product Group Mapping";
                    InventoryGroupMapping: Record "Inventory Group Mapping";
                    UOM: Record "Unit of Measure";
                    ItemUOM: Record "Item Unit of Measure";
                begin
                    Window.UPDATE(1, G_No);
                    if G_No = '' then
                        exit;
                    IF G_Item.GET(G_No) THEN BEGIN
                        Evaluate(LeadTime, G_LeadTime);
                        G_item.Validate("Vendor No.", G_VendorNo);
                        G_item.Validate("Vendor Item No.", G_VendorItemNo);
                        G_item.Validate("Lead Time Calculation", LeadTime);
                        G_Item.Modify();

                        G_ItemVendor.Init();
                        G_ItemVendor.Validate("Item No.", G_No);
                        G_ItemVendor.Validate("Vendor Item No.", G_VendorItemNo);
                        G_ItemVendor.Validate("Vendor No.", G_VendorNo);
                        G_ItemVendor.Validate("Lead Time Calculation", LeadTime);
                        G_ItemVendor.Insert();

                        G_ItemReference.Init();
                        G_ItemReference.Validate("Item No.", G_No);
                        G_ItemReference.Validate("Reference Type", G_ItemReference."Reference Type"::Vendor);
                        G_ItemReference.Validate("Reference Type No.", G_VendorNo);
                        G_ItemReference.Validate("Reference No.", G_VendorItemNo);
                        G_ItemReference.Insert();
                    END;
                END;

            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPreXmlPort()
    begin
        Window.OPEN('Item No.#1##################');
    end;

    trigger OnPostXmlPort()
    begin
        Window.Close();
    end;


    var
        Window: Dialog;
        G_Item: Record Item;
        LeadTime: DateFormula;
        G_ItemVendor: Record "Item Vendor";
        G_ItemReference: Record "Item Reference";
}
