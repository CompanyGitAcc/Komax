pageextension 59167 "TP Purchases & Payables Setup" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Default Accounts")
        {
            group(Komax)
            {
                Caption = 'Komax';
                field("PO Line Price Mandatory"; Rec."PO Line Price Mandatory")
                { ApplicationArea = all; }
            }
        }

    }



}
