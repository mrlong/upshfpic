unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, ADODB, Grids, DBGrids,
  MongoDB,_bson;

type
  TForm1 = class(TForm)
    btn1: TBitBtn;
    ds1: TDataSource;
    dbgrd1: TDBGrid;
    con1: TADOConnection;
    tbl1: TADOTable;
    lbl1: TLabel;
    chk1: TCheckBox;
    procedure btn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

const
  gc_connstr = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Persist Security Info=False';

{$R *.dfm}

{
   结构的设计


}

procedure TForm1.btn1Click(Sender: TObject);
var
  mypicdir : string;
  i ,mycount : Integer;
  mongo  : TMongoConnection;
  coll   : TMongoCollection;
  bson   : TBSONDocument;
  item   : TBSONArrayItem;
  myzidir : string; //存放图字的地方
begin
  mypicdir := ExtractFileDir(system.ParamStr(0)) + '/pic';

  mongo := TMongoConnection.Create('112.124.59.236');
  coll := mongo.GetCollection('shfpics');

  //112.124.59.236
  i := 1;
  mycount := tbl1.RecordCount;
  tbl1.First;
  while not tbl1.Eof do
  begin
    myzidir := mypicdir + '\' + tbl1.FieldByName('zi').AsString;
    if not DirectoryExists(myzidir) then
    begin
      i := i + 1;
      if chk1.Checked then Break;
      lbl1.Caption := Format('%d/%d',[i,mycount]);
      Application.ProcessMessages;
      tbl1.Next;
      Continue;
    end;

    if tbl1.FieldByName('pic').AsBoolean then
    begin
      bson   := TBSONDocument.Create;
      bson.Values['zi'] := TBSONStringItem.Create(UTF8Encode(tbl1.fieldByName('zi').AsString));
      

      item   := TBSONArrayItem.Create;



      coll.save(bson); //保存
    end;

    if chk1.Checked then Break;
    lbl1.Caption := Format('%d/%d',[i,mycount]);
    i := i + 1;
    Application.ProcessMessages;
    tbl1.Next;
  end;

end;

procedure TForm1.FormShow(Sender: TObject);
var
  mystr : string;
begin
  //
  mystr := Format(gc_connstr,['./xhzd.mdb']);
  con1.Close;
  con1.ConnectionString := mystr;
  con1.Open;
  tbl1.Open;
end;

end.
