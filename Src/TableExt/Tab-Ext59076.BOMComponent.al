tableextension 59076 "TP BOM Component" extends "BOM Component"
{
    fields
    {
        field(50000; "Item Translation"; Text[100])
        {
            Caption = 'Item Translation';
            FieldClass = FlowField;
            CalcFormula = Lookup("Item Translation".Description WHERE("Item No." = FIELD("No.")));
        }
    }

}
