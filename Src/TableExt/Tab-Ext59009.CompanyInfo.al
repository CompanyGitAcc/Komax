tableextension 59009 "TP Company Information" extends "Company Information"
{
    fields
    {
        //++BC190.HH
        field(59000; "Legal Representative"; Text[20])
        {
            Caption = 'Legal Representative';
        }
        field(59001; "Customs Ship-to Address"; Text[100])
        {
            Caption = 'Customs Ship-to Address';
        }
        //--BC190.HH
    }
}