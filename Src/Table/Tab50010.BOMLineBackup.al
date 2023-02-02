table 50010 "BOMLine Backup"
{

    fields
    {
        field(1; "Production BOM No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Version Code"; Code[20])
        {
        }
        field(10; Type; Option)
        {
            OptionCaption = ' ,Item,Production BOM';
            OptionMembers = " ",Item,"Production BOM";
        }
        field(11; "No."; Code[20])
        {
        }
        field(12; Description; Text[80])
        {
        }
        field(13; "Unit of Measure Code"; Code[10])
        {
        }
        field(14; Quantity; Decimal)
        {
        }
        field(15; Position; Code[10])
        {
        }
        field(16; "Position 2"; Code[10])
        {
        }
        field(17; "Position 3"; Code[10])
        {
        }
        field(18; "Production Lead Time"; DateFormula)
        {
        }
        field(19; "Routing Link Code"; Code[10])
        {
        }
        field(20; "Scrap %"; Decimal)
        {
        }
        field(21; "Variant Code"; Code[10])
        {
        }
        field(22; Comment; Boolean)
        {
        }
        field(23; "Starting Date"; Date)
        {
        }
        field(24; "Ending Date"; Date)
        {
        }
        field(40; Length; Decimal)
        {
        }
        field(41; Width; Decimal)
        {
        }
        field(42; Weight; Decimal)
        {
        }
        field(43; Depth; Decimal)
        {
        }
        field(44; "Calculation Formula"; Option)
        {
            OptionMembers = " ",Length,"Length * Width","Length * Width * Depth",Weight;
        }
        field(45; "Quantity per"; Decimal)
        {
        }
        field(50000; Certify; Boolean)
        {
            Description = 'STEP005';
        }
        field(50001; "Rout Link"; Code[10])
        {
            TableRelation = "Routing Link";
        }
        field(50002; "Quantity Used"; Decimal)
        {
        }
        field(50003; "Sorce Line No."; Integer)
        {
        }
        field(50004; "Sorce No."; Code[20])
        {
        }
        field(50005; DeleteFalg; Boolean)
        {
            Description = 'STEP1.00 This Field is used PLM import to NAV Programe. Delete Prohibitted';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Production BOM No.", "Version Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

