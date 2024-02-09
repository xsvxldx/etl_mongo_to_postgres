from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, String, BigInteger, Integer, Boolean, TIMESTAMP

Base = declarative_base()

class SubsetMetadata(Base):
    __table_args__ = {'schema': 'stations'}
    __tablename__ = 'metadatas'
    _id = Column(String(24), primary_key=True)
    timestamp_arduino = Column(TIMESTAMP)
    epoch_arduino = Column(BigInteger)
    is_valid = Column(Boolean)

class EtlLog(Base):
    __table_args__ = {'schema': 'metadata'}
    __tablename__ = 'etl_log'
    id = Column(Integer, primary_key=True)
    timestamp = Column(TIMESTAMP)
    table = Column(String(32))
    rows = Column(Integer)
    status = Column(String(32))
    message = Column(String(256))