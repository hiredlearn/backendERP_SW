unit Entidade.Concorrencia;

interface

uses
  Entidade,
  Model.Concorrencia;

type
  TEntidadeConcorrencia = class(TEntidade)
  private
    function GetGetModel: TModelConcorrencia;
    procedure SetGetModel(const Value: TModelConcorrencia);
  public
    procedure CreateProperties; override; 
    // This procedure is responsible for creating the DAO (Data Access Object - a class that handles the querying and SQL execution)
    property GetModel: TModelConcorrencia read GetGetModel write SetGetModel; 
    // This function converts the Model (type TModel) to TModelConcorrencia. It facilitates the handling of Concorrencia data
    procedure ExecutarAntesGravar; override; 
    // This procedure holds all procedures and coding that must be executed before saving the Concorrencia data into the database
  end;

implementation

uses
  DAO,
  Controller,
  untMDB;

{ TEntidadeConcorrencia }

procedure TEntidadeConcorrencia.CreateProperties;
begin
  // DAO is a class that on it’s creation may receive the table, primary key field, and table generator
  DAO := TDAO.Create(Self, 'CONCORRENCIA', 'CON_CODIGO', 'GEN_CONCORRENCIA_ID');
  // Controller is only responsible from validating the model fields value, but in this case it will do nothing as there is no validation for this model/ table
  Controller := TController.Create(Self);
  Model := TModelConcorrencia.Create;
end;

procedure TEntidadeConcorrencia.ExecutarAntesGravar;
begin
  Inherited;
  // Before saving the registry it is checked if Data has value, if it hasn’t it will be valued with the current database datetime
  if GetModel.Data.IsEmpty then
  begin
    // MDB is a class that has utility functions and procedures, 
    // like DataHoraDoBanco that retrieves the datetime current value from the database
    GetModel.Data.Value := MDB.DataHoraDoBanco;
  end;
end;

function TEntidadeConcorrencia.GetGetModel: TModelConcorrencia;
begin
  Result := Model as TModelConcorrencia;
end;

procedure TEntidadeConcorrencia.SetGetModel(const Value: TModelConcorrencia);
begin
  Model := Value;
end;

end.

unit Model.Concorrencia;

interface

uses
  Model,
  Model.Propriedade;

type
  TModelConcorrencia = class(TModel)
  private
    FOperacao: StringType;
    FTabela: StringType;
    FUsuario: IntegerType;
    FChave: IntegerType;
    FData: DateTimeType;
  public
    constructor Create;
    function CriarModel: TModel; override; // CriarModel creates itself
  published
    property Tabela: StringType read FTabela write FTabela;
    property Operacao: StringType read FOperacao write FOperacao;
    property Chave: IntegerType read FChave write FChave;
    property Usuario: IntegerType read FUsuario write FUsuario;
    property Data: DateTimeType read FData write FData;
  end;

implementation

{ TModelConcorrencia }

constructor TModelConcorrencia.Create;
begin
  Inherited;
  // The Codigo field/ property is created in the TEntidade parent class, that’s why there is the above line of code: “Inherited;”
  Codigo.Campo := 'CON_CODIGO';
  Tabela := StringType.Create('CON_TABELA', 100);
  Operacao := StringType.Create('CON_OPERACAO', 100);
  Chave := IntegerType.Create('CON_CHAVE');
  Usuario := IntegerType.Create('USU_CODIGO');
  Data := DateTimeType.Create('CON_DATA');
end;

function TModelConcorrencia.CriarModel: TModel;
begin
  Result := TModelConcorrencia.Create;
end;

end.
