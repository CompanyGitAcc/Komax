tableextension 59083 "TP Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Default Sales Type on Invoice"; Code[20])
        {
            Caption = 'Default Sales Type on Invoice';
            // TableRelation = "Sales Type";
        }

    }

}
