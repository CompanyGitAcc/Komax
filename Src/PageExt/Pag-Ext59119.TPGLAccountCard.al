pageextension 59119 "TP G/L Account Card" extends "G/L Account Card"
{
    layout
    {
        addafter("Income/Balance")
        {
            // field("Balance at Date For HR"; Rec."Balance at Date For HR")
            // {
            //     ApplicationArea = all;
            // }
        }
    }

}
