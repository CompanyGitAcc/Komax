tableextension 59095 "TP Manufacturing Setup" extends "Manufacturing Setup"
{
    fields
    {
        field(50000; "Production Location"; Code[10])
        {
            Caption = 'Production Location';
            TableRelation = Location;
        }
        field(50001; "Production Bin1"; Code[20])
        {
            Caption = 'Production Bin1';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Production Location"));
        }
        field(50002; "Production Bin2"; Code[20])
        {
            Caption = 'Production Bin2';
            TableRelation = Bin.Code;
        }
        field(50003; "Default Movement Worksheet"; Code[20])
        {
            Caption = 'Default Movement Worksheet Name';
            TableRelation = "Whse. Worksheet Name".Name where("Worksheet Template Name" = const('MOVEMENT'));
        }
    }

}
