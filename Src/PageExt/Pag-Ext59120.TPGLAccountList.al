pageextension 59120 "TP G/L Account List" extends "G/L Account List"
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
