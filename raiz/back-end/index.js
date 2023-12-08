const express = require('express');
const mysql = require('mysql2');
const ejs = require('ejs');

const app = express();
const port = 3001;

app.set('view engine', 'ejs');

// Conectar ao banco de dados MySQL
const connection = mysql.createConnection({
  host: 'localhost',
    user: 'vitortwo',
    password: '123456',
    database: 'LojaVitural'
});

connection.connect((err) => {
  if (err) {
    console.error('Erro ao conectar ao banco de dados:', err);
  } else {
    console.log('Conexão com o banco de dados estabelecida com sucesso.');
  }
});

// Rota para criar uma nova venda
app.post('/api/sales', async (req, res) => {
    try {
      const { productName, quantity, price } = req.body;
  
      // Validação dos campos
      if (!productName || !quantity || !price) {
        return res.status(400).json({ error: 'Please provide all required fields.' });
      }
  
      const result = await executeQuery(
        'INSERT INTO sales (productName, quantity, price) VALUES (?, ?, ?)',
        [productName, quantity, price]
      );
  
      res.json({ message: 'Sale created successfully.', saleId: result.insertId });
    } catch (error) {
      console.error('Error creating sale', error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  });
  

// Configurar CORS para permitir comunicação com o frontend
app.use((req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  next();
});

app.use(express.json());

// Restante do código do servidor...
app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});


// Rota para obter o produto mais vendido
app.get('/api/reports/produto-mais-vendido', async (req, res) => {
    try {
      const query = `
        SELECT tipoPeca, SUM(quant) as totalQuantity
        FROM sales
        GROUP BY tipoPeca
        ORDER BY totalQuantity DESC
        LIMIT 1;
      `;
      const [result] = await executeQuery(query);
      res.json(result);
    } catch (error) {
      console.error('Erro ao gerar relatório dos produtos mais vendidos', error);
      res.status(500).json({ error: 'Erro do Servidor Interno' });
    }
  });
  
  // Rota para obter produtos por cliente
  app.get('/api/reports/produtos-por-cliente/:customerId', async (req, res) => {
    try {
      const customerId = req.params.customerId;
      const query = `
        SELECT tipoPeca, quant, preco
        FROM sales
        WHERE customerId = ?
      `;
      const [result] = await executeQuery(query, [customerId]);
      res.json(result);
    } catch (error) {
      console.error('Erro ao gerar relatório de produtos por cliente', error);
      res.status(500).json({ error: 'Erro do Servidor Interno' });
    }
  });
  
  // Rota para obter o consumo médio do cliente
  app.get('/api/reports/average-consumption/:customerId', async (req, res) => {
    try {
      const customerId = req.params.customerId;
      const query = `
        SELECT AVG(quant) as averageConsumption
        FROM sales
        WHERE customerId = ?
      `;
      const [result] = await executeQuery(query, [customerId]);
      res.json(result);
    } catch (error) {
      console.error('Erro ao gerar relatório de consumo médio', error);
      res.status(500).json({ error: 'Erro do Servidor Interno' });
    }
  });
  
  // Rota para obter produtos com baixo estoque
  app.get('/api/reports/low-stock-products', async (req, res) => {
    try {
      const query = `
        SELECT tipoPeca, SUM(quant) as totalQuantity
        FROM sales
        GROUP BY productName
        HAVING totalQuantity < 10;
      `;
      const result = await executeQuery(query);
      res.json(result);
    } catch (error) {
      console.error('Erro ao gerar relatório de produtos com pouco estoque', error);
      res.status(500).json({ error: 'Erro do Servidor Interno' });
    }
  });
  
  // Função para executar consultas no banco de dados
  async function executeQuery(query, params = []) {
    return new Promise((resolve, reject) => {
      connection.query(query, params, (err, results) => {
        if (err) {
          reject(err);
        } else {
          resolve(results);
        }
      });
    });
  }
  