#include "matrix.h"
#include <QDebug>
using namespace std;


Matrix::Matrix() : QObject()
{
    size = 3;
    mas = new float*[size];
    for(int i=0; i<size; i++)
    {
        mas[i]=new float[size];
    }
    for(int i=0; i<size; i++)
    {
        for(int j=0; j<size; j++)
        {
            mas[i][j]=0;
        }
    }
}

Matrix::Matrix(int size_) : QObject()
{
    size=size_;
    mas = new float*[size];
    for(int i=0; i<size; i++)
    {
        mas[i]=new float[size];
    }
    for(int i=0; i<size; i++)
    {
        for(int j=0; j<size; j++)
        {
            mas[i][j]=0;
        }
    }
}

int Matrix::getSize()
{
    return this->size;
}

void Matrix::reload(int s)
{
    for (int i =0; i < this->size; i++) {
        delete[] mas[i];
    }
    delete[] mas;

    this->size = s;
    mas = new float*[size];
    for(int i=0; i<size; i++)
    {
        mas[i]=new float[size];
    }
    for(int i=0; i<size; i++)
    {
        for(int j=0; j<size; j++)
        {
            mas[i][j]=0;
        }
    }
}

void Matrix::degree(int d)
{
    Matrix m2(this->size);
    m2 = (*this);
    for(int i=0; i<d-1; i++)
    {
        m2 = m2 * (*this);
    }
    *this = m2;
}

Matrix::Matrix(const Matrix& m)
{
    size=m.size;
    mas = new float*[size];
    for(int i=0; i<size; i++)
    {
        mas[i]=new float[size];
    }
    for(int i=0; i<m.size; i++)
    {
        for(int j=0; j<m.size; j++)
        {
            mas[i][j]=m.mas[i][j];
        }
    }
}

Matrix Matrix::operator = (Matrix c)
{
    size=c.size;
    for(int i=0; i<c.size; i++)
    {
        for(int j=0; j<c.size; j++)
        {
            mas[i][j]=c.mas[i][j];
        }
    }
    return *this;
}


float Matrix::getElement(int i, int j)
{
    return this->mas[i][j];
}

void Matrix::setElement(QString a, int i, int j)
{
    float a_ = a.toFloat();
    this->mas[i][j] = a_;
    emit matrixChanged();
}

void Matrix::print()
{
    int l = this->size;

    for (int i = 0; i < l; i++) {
        for (int j = 0; j < l; j++) {
            qDebug() << this->mas[i][j] << " ";
        }
        qDebug() << "\n";
    }
}

void Matrix::setSize(int s) {
    this->size = s;
    emit sizeChanged();
}

float** Matrix::getMas() {
    return this->mas;
}

Matrix Matrix::operator * (Matrix c)
{
    Matrix m2(c.size);
    size=c.size;
    float buf=0;
    int xk=0, yk=0;
    for(int i=0; i<size; i++)
    {
        for(int j=0; j<size; j++)
        {
            for(int k=0; k<size; k++)
            {
                buf+=this->mas[i][k]*c.mas[k][j];
            }
            m2.mas[i][j]=buf;
            buf=0;
            yk++;
        }
        yk=0;
        xk++;
    }
    return m2;
}

Matrix Matrix::operator + (Matrix c)
{
    Matrix m2(c.size);
    for(int i=0; i<c.size; i++)
    {
        for(int j=0; j<c.size; j++)
        {
            m2.mas[i][j]=this->mas[i][j]+c.mas[i][j];
        }
    }
    return m2;
}

void Matrix::scalar_multi(Matrix m, int n, float a){
    for(int row = 0; row < n; row++)
        for(int col = 0; col < n; col++){
            m.mas[row][col] *= a;
        }
}

void Matrix::clear(Matrix arr, int n)
{
    for(int i = 0; i < n; i++)
        delete[] arr.mas[i];
    delete[] arr.mas;
}
float Matrix::det(Matrix matrix, int n) //квадратная матрица размера n*n
{
    Matrix B(matrix);
    //приведение матрицы к верхнетреугольному виду
    for(int step = 0; step < n - 1; step++)
        for(int row = step + 1; row < n; row++)
        {
            float coeff = -B.mas[row][step] / B.mas[step][step]; //метод Гаусса
            for(int col = step; col < n; col++)
                B.mas[row][col] += B.mas[step][col] * coeff;
        }
    //Рассчитать определитель как произведение элементов главной диагонали
    float Det = 1;
    for(int i = 0; i < n; i++)
        Det *= B.mas[i][i];
    //Очистить память
    clear(B, n);
    return Det;
}
Matrix Matrix::inverse(Matrix A, int n)
{
    float N1 = 0, Ninf = 0; //норма матрицы по столбцам и по строкам
     Matrix A0(A);       //инициализация начального приближения
     for(size_t row = 0; row < n; row++){
         float colsum = 0, rowsum = 0;
         for(size_t col = 0; col < n; col++){
             rowsum += fabs(A0.mas[row][col]);
             colsum += fabs(A0.mas[col][row]);
         }
         N1 = std::max(colsum, N1);
         Ninf = std::max(rowsum, Ninf);
     }
     //транспонирование
     for(size_t row = 0; row < n - 1; row++){
         for(size_t col = row + 1; col < n; col++)
             std::swap(A0.mas[col][row], A0.mas[row][col]);
     }
     scalar_multi(A0, n, (1 / (N1 * Ninf))); //нормирование матрицы
     //инициализация удвоенной единичной матрицы нужного размера
     Matrix E2(n);// = new float*[n];
     for(int row = 0; row < n; row++)
     {
         //E2[row] = new float[n];
         for(int col = 0; col < n; col++){
             if(row == col)
                 E2.mas[row][col] = 2;
             else
                 E2.mas[row][col] = 0;
         }
     }
     Matrix inv = A0; //A_{0}
     float EPS = 0.001;   //погрешность
     if(det(A, n) != 0){ //если матрица не вырождена
         while(fabs(det(A * inv, n) - 1) >= EPS) //пока |det(A * A[k](^-1)) - 1| >= EPS
         {
             Matrix prev(inv); //A[k-1]
             inv = A * prev;   //A.(A[k-1]^(-1))
             scalar_multi(inv, n, -1);         //-A.(A[k-1]^(-1))
             inv + E2;                   //2E - A.(A[k-1]^(-1))
             inv = prev * inv; //(A[k-1]^(-1)).(2E - A.(A[k-1]^(-1)))
             clear(prev, n);
         }
         //вывод матрицы на экран
         //show(inv, n);
     }
     else
         printf("Impossible\n");
     clear(A, n);
     clear(E2, n);
     return inv;
}
