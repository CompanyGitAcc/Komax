table 50045 "Order Type Location Bin Setup"
{

    fields
    {
        field(1; "Order Type"; Option)
        {
            OptionCaption = 'Standard,Warranty,Exchange,TEMP.OUT,Self Used,Prod. Scrap,RD Scrap,Standard Part,Standard Machine,Warranty Part,Warranty Machine';
            OptionMembers = Standard,Warranty,Exchange,"TEMP.OUT","Self Used","Prod. Scrap","RD Scrap","Standard Part","Standard Machine","Warranty Part","Warranty Machine";
        }
        field(2; "Default Location Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = Location;
        }
        field(3; "Default Bin Code"; Code[20])
        {
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Default Location Code"));
        }
    }

    keys
    {
        key(Key1; "Order Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

