table 50022 "Item Bin Inventory"
{
    // //STEP1.00  110401  Gary  This Table will show inventory detail

    LookupPageID = "Item Bin Inventory";

    fields
    {
        field(1; "Item No."; Code[20])
        {
            TableRelation = Item."No.";

            trigger OnValidate()
            begin
                Item.RESET;
                Item.SETRANGE(Item."No.", "Item No.");
                IF Item.FIND('-') THEN
                    "Unit Of Measure" := Item."Base Unit of Measure";
            end;
        }
        field(2; "Location Code"; Code[10])
        {
            TableRelation = Location;
        }
        field(3; "Bin Code"; Code[20])
        {
            TableRelation = IF ("Zone Code" = FILTER('')) Bin.Code WHERE("Location Code" = FIELD("Location Code"))
            ELSE
            IF ("Zone Code" = FILTER(<> '')) Bin.Code WHERE("Location Code" = FIELD("Location Code"),
                                                                             "Zone Code" = FIELD("Zone Code"));

            trigger OnValidate()
            begin
                IF ("Bin Code" <> xRec."Bin Code") AND ("Bin Code" = '') THEN
                    "Zone Code" := '';
                IF ("Bin Code" <> xRec."Bin Code") AND ("Bin Code" <> '') THEN BEGIN
                    Bin.GET("Location Code", "Bin Code");
                    "Zone Code" := Bin."Zone Code";
                END;
            end;
        }
        field(4; "Unit Of Measure"; Code[10])
        {
            Editable = false;
        }
        field(5; "Zone Code"; Code[10])
        {
            TableRelation = Zone.Code WHERE("Location Code" = FIELD("Location Code"));
        }
        field(6; Quantity; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Item No.", "Location Code", "Bin Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Item: Record Item;
        Bin: Record Bin;
}

