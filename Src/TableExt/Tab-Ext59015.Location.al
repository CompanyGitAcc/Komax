tableextension 59015 "TP Location" extends Location
{
    fields
    {
        //==============================================================================
        //++NAV2009  说明：以下字段是从老系统迁移过来的字段，部分不再使用的字段已注释掉
        //==============================================================================  
        field(50000; "Inbound Production Bin Code"; Code[20])
        {
            Caption = 'Inbound Production Bin Code';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD(Code));
        }
    }
}