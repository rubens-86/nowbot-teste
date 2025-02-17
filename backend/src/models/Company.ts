class Company {
  public id!: number;
  public name!: string;

  constructor(data: Partial<Company>) {
    Object.assign(this, data);
  }

  static async findAll(): Promise<Company[]> {
    // Implementação temporária
    return [new Company({ id: 1, name: 'Empresa Padrão' })];
  }
}

export default Company; 