
# anaconda(또는 miniconda)가 존재하지 않을 경우 설치해주세요!
if [ ! -x "$HOME/miniconda3/bin/conda" ]; then
    curl -o /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash /tmp/miniconda.sh -b -p "$HOME/miniconda3"
fi

source "$HOME/miniconda3/etc/profile.d/conda.sh"


# Conda 환셩 생성 및 활성화
conda tos accept
conda create -n myenv python=3.13 -y
conda activate myenv

## 건드리지 마세요! ##
python_env=$(python -c "import sys; print(sys.prefix)")
if [[ "$python_env" == *"/envs/myenv"* ]]; then
    echo "[INFO] 가상환경 활성화: 성공"
else
    echo "[INFO] 가상환경 활성화: 실패"
    exit 1 
fi

# 필요한 패키지 설치
pip install mypy

# Submission 폴더 파일 실행
cd submission || { echo "[INFO] submission 디렉토리로 이동 실패"; exit 1; }
 
for file in *.py; do
    p_no=$(echo "$file" | cut -d_ -f2 | cut -d. -f1)
    python "$file" < "../input/${p_no}_input" > "../output/${p_no}_output"
done

# mypy 테스트 실행 및 mypy_log.txt 저장
mypy *.py > ../mypy_log.txt 2>&1

# conda.yml 파일 생성
conda env export > ../conda.yml

# 가상환경 비활성화
conda deactivate