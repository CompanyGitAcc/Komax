tableextension 59106 "TP Purchases & Payables Setup" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "PO Line Price Mandatory"; Boolean)
        {
            Caption = 'PO Line Price Mandatory';
            // TableRelation = "Sales Type";
        }

    }

}
